# 🍽️ Revo - AI-Powered Restaurant Review & Sentiment Analysis Platform

## 🌟 Project Overview

**Revo** revolutionizes restaurant reviews by combining Flutter-powered mobile apps with AI-driven sentiment analysis. This comprehensive platform empowers diners to share authentic feedback while providing restaurant owners with actionable insights through advanced machine learning.

## 🚀 Core Features

### 📱 Mobile App (Flutter)
- **Multi-role Authentication**:
  - Secure login for users, restaurant owners, and admins
  - Google Sign-In integration
  - Role-based access control

- **Interactive Restaurant Discovery**:
  - Geolocation-based restaurant browsing
  - Advanced filtering and search
  - Detailed restaurant profiles with menus and photos

- **Smart Review System**:
  - Text and image reviews
  - AI-powered sentiment analysis (Positive/Negative)
  - Rating visualization with FlChart

- **User Engagement**:
  - Personalized recommendations
  - Favorite restaurants
  - Review history tracking

- **Owner Dashboard**:
  - Sentiment analysis analytics
  - Review response system
  - Event and promotion management


- **AI Integration**:
  - Review sentiment monitoring
  - Trend analysis
  - Data export capabilities

## 🛠 Enhanced Tech Stack

| Component          | Technologies Used |
|--------------------|-------------------|
| **Frontend**       | Flutter (Mobile), React (Web) |
| **Backend**        | Firebase (Auth, Firestore, Storage, Realtime DB) |
| **AI/ML**          | Python (Scikit-learn, SVM), Google Generative AI |
| **Maps & Location**| FlutterMap, Location Services |
| **State Management**| Flutter BLoC, GetIt |
| **UI/UX**         | Lottie Animations, Shimmer Effects, Custom Charts |
| **Utilities**     | Image Picker, Cached Network Images, Internationalization |

## 🔍 Detailed Features Breakdown

### � User Experience
- **Onboarding Flow**: Animated splash screens and guided tour
- **Multi-language Support**: Internationalization with intl_utils
- **Offline Capabilities**: Cached data and map tiles
- **Responsive Design**: Adapts to all screen sizes with ScreenUtil

### 📊 Analytics & Visualization
- **Sentiment Trends**: Syncfusion Flutter Charts
- **Review Insights**: Interactive data visualizations
- **Performance Metrics**: Owner-facing analytics dashboard

### 🛡️ Security & Performance
- **Secure Authentication**: Firebase Auth with role management
- **Optimized Media**: Cached network images and storage
- **Efficient State**: BLoC pattern for predictable state management

## 🧠 Machine Learning Implementation
- **Custom-trained Models**: SVM and Random Forest classifiers
- **High Accuracy**: 94% sentiment classification rate
- **Continuous Learning**: Adapts to new review patterns
- **Multi-modal Analysis**: Text and image context understanding

## 📱 Screenshots (Conceptual)
1. **User App**:
   - Restaurant discovery map view
   - Review submission interface
   - Sentiment visualization screens
   - Personalized recommendation feed

2. **Owner App**:
   - Review analytics dashboard
   - Response management
   - Business performance metrics


## � Getting Started

### Prerequisites
- Flutter 3.5.4+
- Firebase project configured
- used api key for ml learning model

### Installation
```bash
flutter pub get
flutter pub run flutter_native_splash:create
flutter pub run intl_utils:generate
```

### Configuration
1. Add your Firebase configuration files
2. Set up Google Sign-In credentials
3. Configure ML model endpoints

## 📈 Future Roadmap
- Integration with reservation systems
- Advanced NLP for aspect-based sentiment analysis
- Loyalty program integration
- Predictive analytics for restaurant trends

## 👥 Developed Mobile and Firebase features
- Kyrillos Nabil Zakhary - Project Lead & Flutter Developer


## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details.
