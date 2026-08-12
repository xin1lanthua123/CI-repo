package hipstershop;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

import hipstershop.Demo.Ad;
import hipstershop.Demo.AdRequest;
import hipstershop.Demo.AdResponse;
import io.grpc.stub.StreamObserver;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import org.junit.jupiter.api.Test;

class AdServiceTest {

  private Object createServiceImpl() throws Exception {
    Class<?> clazz = Class.forName("hipstershop.AdService$AdServiceImpl");
    Constructor<?> constructor = clazz.getDeclaredConstructor();
    constructor.setAccessible(true);
    return constructor.newInstance();
  }

  private AdResponse callGetAds(Object serviceImpl, AdRequest request) throws Exception {
    List<AdResponse> responses = new ArrayList<>();
    List<Throwable> errors = new ArrayList<>();
    boolean[] completed = {false};

    StreamObserver<AdResponse> observer =
        new StreamObserver<>() {
          @Override
          public void onNext(AdResponse response) {
            responses.add(response);
          }

          @Override
          public void onError(Throwable throwable) {
            errors.add(throwable);
          }

          @Override
          public void onCompleted() {
            completed[0] = true;
          }
        };

    Method getAds =
        serviceImpl.getClass().getMethod(
            "getAds", AdRequest.class, StreamObserver.class);

    getAds.invoke(serviceImpl, request, observer);

    assertEquals(0, errors.size());
    assertEquals(true, completed[0]);
    assertEquals(1, responses.size());

    return responses.get(0);
  }

  @Test
  void shouldReturnAdsForKnownCategory() throws Exception {
    Object serviceImpl = createServiceImpl();

    AdRequest request =
        AdRequest.newBuilder()
            .addContextKeys("clothing")
            .build();

    AdResponse response = callGetAds(serviceImpl, request);

    assertEquals(1, response.getAdsCount());
    assertEquals(
        "/product/66VCHSJNUP",
        response.getAds(0).getRedirectUrl());
  }

  @Test
  void shouldReturnRandomAdsWhenNoCategoryIsProvided() throws Exception {
    Object serviceImpl = createServiceImpl();

    AdRequest request = AdRequest.newBuilder().build();

    AdResponse response = callGetAds(serviceImpl, request);

    assertEquals(2, response.getAdsCount());

    for (Ad ad : response.getAdsList()) {
      assertFalse(ad.getText().isEmpty());
      assertFalse(ad.getRedirectUrl().isEmpty());
    }
  }

  @Test
  void shouldReturnRandomAdsForUnknownCategory() throws Exception {
    Object serviceImpl = createServiceImpl();

    AdRequest request =
        AdRequest.newBuilder()
            .addContextKeys("unknown-category")
            .build();

    AdResponse response = callGetAds(serviceImpl, request);

    assertEquals(2, response.getAdsCount());

    for (Ad ad : response.getAdsList()) {
      assertFalse(ad.getText().isEmpty());
      assertFalse(ad.getRedirectUrl().isEmpty());
    }
  }
}
