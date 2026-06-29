// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EventList)
final eventListProvider = EventListProvider._();

final class EventListProvider
    extends $NotifierProvider<EventList, List<EventModel>> {
  EventListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventListHash();

  @$internal
  @override
  EventList create() => EventList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<EventModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<EventModel>>(value),
    );
  }
}

String _$eventListHash() => r'f70eacea67f8b5fa3ff1ebf75543163823c130dc';

abstract class _$EventList extends $Notifier<List<EventModel>> {
  List<EventModel> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<EventModel>, List<EventModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<EventModel>, List<EventModel>>,
              List<EventModel>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
