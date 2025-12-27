part of 'discover_bloc.dart';

@freezed
class DiscoverEvent with _$DiscoverEvent {
  const factory DiscoverEvent.loadDiscover({@Default(1) int page}) =
      LoadDiscover;
  const factory DiscoverEvent.likeUser(String userId) = LikeUser;
  const factory DiscoverEvent.passUser(String userId) = PassUser;
  const factory DiscoverEvent.nextCard() = NextCard;
  const factory DiscoverEvent.resetCards() = ResetCards;
}
