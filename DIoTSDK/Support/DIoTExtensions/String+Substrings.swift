//
//  String+Substrings.swift
//  DIoT_Demo_iOS
//
//  Created by Andrey Maslennikov on 07.04.2022.
//

public extension String {
    /// Returns substring of original string fromPosition to toPosition. Throwable.
    ///
    /// - Parameters:
    ///   - fromPosition: start position of substring
    ///   - toPosition: end position of substring
    /// - Returns: substring of string
    /// - Throws: if fromPosition is bigger than toPosition than toPositionIsSmallerThanFromPosition will be thrown
    func substring(from fromPosition: Int, to toPosition: Int) throws -> String {
        guard fromPosition < toPosition else { throw SubstringError.toPositionIsSmallerThanFromPosition }

        guard fromPosition >= 0 else { throw SubstringError.fromPositionCannotBeLessZero }

        guard toPosition < count else { throw SubstringError.toPositionCannotBeMoreStringLength }

        let startSubstringIndex = index(startIndex, offsetBy: fromPosition)
        let endSubstringIndex = index(startIndex, offsetBy: toPosition)

        let substring = self[startSubstringIndex...endSubstringIndex]

        return String(substring)
    }

    /// Returns substring of original string fromPosition with specified length
    ///
    /// - Parameters:
    ///   - fromPosition: start position of substring
    ///   - length: length of substring
    /// - Returns: substring of string
    func substring(from fromPosition: Int, length: Int) throws -> String {
        return try substring(from: fromPosition, to: fromPosition + length - 1)
    }
}

public enum SubstringError {
    case toPositionIsSmallerThanFromPosition
    case fromPositionCannotBeLessZero
    case toPositionCannotBeMoreStringLength
}

// MARK: Error
extension SubstringError: Error {}
