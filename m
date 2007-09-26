Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 01:13:52 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8Q8DkoC028526
	for <xfs@oss.sgi.com>; Wed, 26 Sep 2007 01:13:48 -0700
Date: Wed, 26 Sep 2007 10:13:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] cleanup vnode useage in xfs_dm.c
Message-ID: <20070926081344.GA32414@lst.de>
References: <20070923114339.GB9585@lst.de> <46F88602.4040104@sgi.com> <20070925194424.GA1714@lst.de> <46F9B766.8070808@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F9B766.8070808@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Vlad Apostolov <vapo@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Sep 26, 2007 at 11:35:34AM +1000, Vlad Apostolov wrote:
> Christoph Hellwig wrote:
> >I have a patch in the queue, as usual :)
> >
> >--
> >
> >Kill 2.4 compat ifdefs in dmapi.
> I checked in the patch in the XFS development tree. I guess you
> probably have or are planning patches for the same cleanup in
> xfs.h, dmapi_register.c and dmapi_sysent.c?

Ah, haven't looked at those.  If everyone is fine with that I can
send these patches.
