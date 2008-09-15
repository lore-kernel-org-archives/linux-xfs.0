Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 17:24:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8F0OdgV022560
	for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:24:40 -0700
Received: from ogre.sisk.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7839C129C94F
	for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:26:09 -0700 (PDT)
Received: from ogre.sisk.pl (ogre.sisk.pl [217.79.144.158]) by cuda.sgi.com with ESMTP id exq5ffdTEuum8N6t for <linux-xfs@oss.sgi.com>; Sun, 14 Sep 2008 17:26:09 -0700 (PDT)
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: XFS does not recognise mount options in 2.6.27-rc6
Date: Mon, 15 Sep 2008 02:31:00 +0200
References: <pan.2008.09.14.18.53.20@telenet.be>
In-Reply-To: <pan.2008.09.14.18.53.20@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809150231.01220.rjw@sisk.pl>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Frederik Himpe <fhimpe@telenet.be>
Cc: linux-kernel@vger.kernel.org, linux-xfs@oss.sgi.com

On Sunday, 14 of September 2008, Frederik Himpe wrote:
> In 2.6.27-rc6, XFS still does not recognise mount options like logbufs and 
> others. Because of this, at boot time it fails to mount the partitions rw, 
> making the system unusable.

Was 2.6.26 OK?

Rafael
