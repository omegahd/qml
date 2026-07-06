#ifndef GOVALUE_H
#define GOVALUE_H

// Unfortunatley we need access to private bits, because the
// whole dynamic meta-object concept is sadly being hidden
// away, and without it this package wouldn't exist.
#include <private/qmetaobject_p.h>

#include <QtQuick/QQuickFramebufferObject>

#include "capi.h"

class GoValueMetaObject;

QMetaObject *metaObjectFor(GoTypeInfo *typeInfo);

class GoValue : public QObject
{
    Q_OBJECT

public:
    GoRef ref;
    GoTypeInfo *typeInfo;

    GoValue(GoRef ref, GoTypeInfo *typeInfo, QObject *parent);
    virtual ~GoValue();

    void activate(int propIndex);

private:
    GoValueMetaObject *valueMeta;
};

// Custom types with a Paint method render through the OpenGL-backed
// framebuffer object item. Qt 6 removed the FramebufferObject render
// target of QQuickPaintedItem that was used with Qt 5, and its raster
// Image target cannot host native GL painting.
class GoPaintedValue : public QQuickFramebufferObject
{
    Q_OBJECT

public:
    GoRef ref;
    GoTypeInfo *typeInfo;

    GoPaintedValue(GoRef ref, GoTypeInfo *typeInfo, QObject *parent);
    virtual ~GoPaintedValue();

    void activate(int propIndex);

    virtual Renderer *createRenderer() const;

private:
    GoValueMetaObject *valueMeta;
};

#endif // GOVALUE_H

// vim:ts=4:sw=4:et:ft=cpp
