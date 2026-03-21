String pascalCase(String input) =>
    input.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();
