
all:	
	swift build -c debug

project:
	swift package generate-xcodeproj

clean:
	rm -rf .build Package.pins Package.resolved


