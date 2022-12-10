export packId=101
export versionId=2296

docker build -t minecraft-ftb-${packId}-${versionId} --build-arg packId=${packId} --build-arg versionId=${versionId} .

