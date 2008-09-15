Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Sep 2008 02:01:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F91pBI005605
	for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:01:52 -0700
Received: from harold.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BDE2B129CFF5
	for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:03:21 -0700 (PDT)
Received: from harold.telenet-ops.be (harold.telenet-ops.be [195.130.133.65]) by cuda.sgi.com with ESMTP id ZDnUNYun2lWuVZR3 for <linux-xfs@oss.sgi.com>; Mon, 15 Sep 2008 02:03:21 -0700 (PDT)
Date: Mon, 15 Sep 2008 11:03:20 +0200
From: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Message-ID: <20080915090320.GA19851@telenet.be>
References: <pan.2008.09.14.18.53.20@telenet.be> <200809150231.01220.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809150231.01220.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com

On Mon, Sep 15, 2008 at 02:31:00AM +0200, Rafael J. Wysocki wrote:
> On Sunday, 14 of September 2008, Frederik Himpe wrote:
> > In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> > others. Because of this, at boot time it fails to mount the partitions rw, 
> > making the system unusable.
> 
> Was 2.6.26 OK?

Yes, with 2.6.26 it mounts fine. According to that earlier message on
the list, this is a regression introduced in either 2.6.27-rc2 or
2.6.27-rc3.

-- 
Frederik Himpe
