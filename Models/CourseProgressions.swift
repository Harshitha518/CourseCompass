

import Foundation

// Contains progressions (which course can be taken after certain course) and is sperated by subject
struct CourseProgressions {
    
    // Specific prerequisites for AP courses only (more complex)
    static let apPrereqs: [String: [String]] = [
        "AP Environmental Science": ["Environmental Science CP", "Environmental Science H", "Biology H", "Biology CP", "Chemistry H", "Physics CP", "Physics H"],
        "AP Biology": ["Biology CP", "Biology H"],
        "AP Chemistry": ["Chemistry CP", "Chemistry H"],
        "AP Physics I": ["Physics CP", "Physics H", "Chemistry H", "Biology H"],
        "AP Physics II": ["AP Physics I", "Physics H", "Physics CP"],
        "AP Physics C": ["AP Physics I", "AP Physics II", "Physics H"],
        "AP Precalculus": ["Algebra II/Trigonometry CP", "Algebra II/Trigonometry H"],
        "AP Statistics": ["AP Precalculus", "Precalculus CP", "Calculus CP", "AP Calculus AB"],
        "AP Calculus AB": ["Precalculus CP", "Precalculus H", "AP Precalculus", "Calculus CP"],
        "AP Calculus BC": ["AP Calculus AB"],
        "AP US History": ["US History I H", "US History I CP"],
        "AP Language and Composition": ["English II H"],
        "AP Literature": ["AP Language and Composition", "English III H"]
    ]

    // Math progression
    static let mathProgressionGraph: [String: [String]] = [
        "Algebra I CP": ["Geometry CP", "Geometry H"],
        "Geometry CP": ["Algebra II CP", "Algebra II/Trigonometry CP", "Algebra II/Trigonometry H"],
        "Geometry H": ["Algebra II/Trigonometry H"],
        "Algebra II CP": ["Algebra III/Trigonometry CP", "Precalculus CP", "Precalculus H", "Selected Topics CP"],
        "Algebra II/Trigonometry CP": ["Precalculus CP", "Precalculus H", "AP Precalculus"],
        "Statistics CP": [],
        "Algebra II/Trigonometry H": ["Precalculus H", "AP Precalculus"],
        "Algebra III/Trigonometry CP": ["Selected Topics CP", "Statistics CP", "Precalculus CP"],
        "Precalculus CP": ["Calculus CP", "AP Calculus AB", "AP Statistics", "Statistics CP"],
        "Calculus CP": ["AP Calculus AB", "AP Statistics"],
        "Precalculus H": ["AP Calculus AB", "AP Statistics"],
        "AP Precalculus": ["AP Calculus AB", "AP Statistics"],
        "AP Calculus AB": ["AP Calculus BC", "AP Statistics"],
        "AP Calculus BC": [],
        "Selected Topics CP": [],
        "AP Statistics": []
    ]

    // Science Progression
    static let scienceProgressionGraph: [String: [String]] = [
        "Environmental Science CP": ["Biology CP"],
        "Biology CP": ["Chemistry CP", "Geophysical CP"],
        "Geophysical CP": ["Physics CP", "Chemistry CP", "Organic Chemistry CP", "Anatomy & Physiology CP"],
        "Chemistry CP": ["Geophysical CP", "Physics CP", "Organic Chemistry CP", "Anatomy & Physiology CP", "Environmental Science CP", "AP Environmental Science", "AP Biology", "AP Chemistry"],
        "Physics CP": ["AP Physics I"],
        "Environmental Science H": ["Biology H"],
        "Biology H": ["Chemistry H", "AP Environmental Science", "AP Biology", "AP Physics I", "Physics H"],
        "Chemistry H": ["Physics H", "AP Environmental Science", "AP Biology", "AP Chemistry", "AP Physics I", "Environmental Science H"],
        "Physics H": ["AP Physics I"],
        "AP Environmental Science": [],
        "AP Chemistry": ["Biology H"],
        "AP Biology": [],
        "AP Physics I": ["AP Physics II", "AP Physics C"],
        "AP Physics II": [],
        "AP Physics C": [],
        "Anatomy & Physiology CP": [],
        "Organic Chemistry CP": []
    ]

    // English progression
    static let englishProgressionGraph: [String: [String]] = [
        "English I CP": ["English II CP", "English II H"],
        "English I H": ["English II H"],
        "English II CP": ["English III CP", "English III H"],
        "English II H": ["English III H", "AP Language and Composition"],
        "English III CP": ["English IV CP", "English IV H"],
        "English III H": ["English IV H", "AP Literature"],
        "AP Language and Composition": ["AP Literature"],
        "AP Literature": [],
        "English IV CP": [],
        "English IV H": []
    ]

    // History prgression
    static let historyProgressionGraph: [String: [String]] = [
        "World History/Cultures CP": ["US History I CP", "US History I H"],
        "World History H": ["US History I H"],
        "US History I CP": ["US History II CP", "AP US History"],
        "US History I H": ["AP US History"],
        "US History II CP": ["AP European History", "AP Human Geography", "AP World History", "AP U.S. Government and Politics", "AP Psychology", "AP Microeconomics/AP Macroeconomics"],
        "AP US History" : ["AP European History", "AP Human Geography", "AP World History", "AP U.S. Government and Politics", "AP Psychology", "AP Microeconomics/AP Macroeconomics"],
        "AP European History" : [],
        "AP Human Geography" : [],
        "AP World History" : [],
        "AP U.S. Government and Politics" : [],
        "AP Psychology" : [],
        "AP Microeconomics/AP Macroeconomics" : []
    ]

    // Language progression
    static let langProgressionGraph: [String: [String]] = [
        "Level I CP - " : ["Level II CP - "],
        "Level II CP - " : ["Level III CP - "],
        "Level III CP - " : ["Level IV CP - "],
        "Level IV CP - " : [ "AP "],
        "AP " : ["Study Hall"],
        "Latin I CP" : ["Latin II CP"],
        "Latin II CP" : ["Latin III CP"],
        "Latin III CP" : ["Latin IV CP"],
        "Latin IV CP" : [],
        "American Sign Language I CP" : ["American Sign Language II CP"],
        "American Sign Language II CP" : ["American Sign Language III CP"],
        "American Sign Language III CP" : ["American Sign Language IV CP"],
        "American Sign Language IV CP" : []
    ]
    
}
