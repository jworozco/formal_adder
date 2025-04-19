# Formal Adder

This repository contains the design of an adder and a 32 bit multiplier, the code is tested using formal verification. The project focuses on creating a reliable and efficient adder/multiplier circuit using formal verification techniques.

## Features

- **Formal Verification**: Ensures the correctness of the adder design.
- **Modular Design**: Easy to integrate into larger systems.
- **Scalable**: Supports various bit-width configurations.

## Repository Structure

- adder.sv, pm32.sv: Contain the source code for the designs and the formal properties being tested.
- adder.sby and pm32.sby: Includes test cases for verifying the functionality.

## Getting Started

1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/formal_adder.git
    cd formal_adder
    ```

2. Install dependencies:
    https://symbiyosys.readthedocs.io/en/latest/

3. Run tests:
    ```bash
    sby -f adder.sby

    sby -f adder_bug.sby

    sby -f pm32.sby
    ```

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to all contributors and the open-source community for their support.