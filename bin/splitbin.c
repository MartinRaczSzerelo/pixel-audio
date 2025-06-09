/*
 * splitbin.c - Part of the Pixel Audio Framework (VEDA)
 * Copyright (C) 2025 Martin Rácz
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 4096

void print_usage(const char *progname) {
    printf("Usage: %s <file> chunk_size\n", progname);
}

int main(int argc, char *argv[]) {
    if (argc != 3) {
        print_usage(argv[0]);
        return 1;
    }

    const char *input_filename = argv[1];
    long chunk_size = atol(argv[2]);

    if (chunk_size <= 0) {
        fprintf(stderr, "Error: Invalid chunk size.\n");
        return 1;
    }

    FILE *input = fopen(input_filename, "rb");
    if (!input) {
        perror("Error opening input file");
        return 1;
    }

    unsigned char buffer[BUFFER_SIZE];
    int chunk_index = 0;
    size_t bytes_read_total = 0;

    while (!feof(input)) {
        char output_filename[256];
        snprintf(output_filename, sizeof(output_filename), "%03d.pcm", chunk_index);
        FILE *output = fopen(output_filename, "wb");
        if (!output) {
            perror("Error creating output chunk file");
            fclose(input);
            return 1;
        }

        long bytes_written = 0;
        while (bytes_written < chunk_size && !feof(input)) {
            size_t to_read = (chunk_size - bytes_written < BUFFER_SIZE) ? (chunk_size - bytes_written) : BUFFER_SIZE;
            size_t bytes_read = fread(buffer, 1, to_read, input);
            if (bytes_read > 0) {
                fwrite(buffer, 1, bytes_read, output);
                bytes_written += bytes_read;
                bytes_read_total += bytes_read;
            } else {
                break;
            }
        }

        fclose(output);
        chunk_index++;
    }

    fclose(input);

    return 0;
}