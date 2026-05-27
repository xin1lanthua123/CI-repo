ARG MULTIPLATFORM=linux/amd64,linux/arm64

FROM --platform=$MULTIPLATFORM  python AS BUILDER

COPY dependency_dir dest

RUN download_dependency_command

COPY . .

RUN build_command

FROM scratch AS RUNTIME

COPY --link --from=BUILDER source dest

COPY --link --from=BUILDER source dest

USER app

EXPOSE 8080

ENTRYPOINT [ "executable" ]

CMD [ "executable" ]