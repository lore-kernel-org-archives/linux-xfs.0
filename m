Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47644 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932942AbdDEKzO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Apr 2017 06:55:14 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20170405104205.GZ22845@eguan.usersys.redhat.com>
References: <20170405104205.GZ22845@eguan.usersys.redhat.com> <149132130900.18980.537296385250153410.stgit@warthog.procyon.org.uk> <149132132595.18980.156040870381065105.stgit@warthog.procyon.org.uk>
Subject: Re: [PATCH 3/4] xfstests: Partially expand the documentation [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2630.1491389712.1@warthog.procyon.org.uk>
Date: Wed, 05 Apr 2017 11:55:12 +0100
Message-ID: <2631.1491389712@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: dhowells@redhat.com, linux-xfs@vger.kernel.org, hch@infradead.org, amir73il@gmail.com, david@fromorbit.com, fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org

Eryu Guan <eguan@redhat.com> wrote:

> Hmm, NC_PROG is not defined/used anymore, perhaps it's not a good
> example for document purpose. How about $KILLALL_PROG? It's often
> forgotten and it could be a reminder in doc.

I'll switch to that.

David
