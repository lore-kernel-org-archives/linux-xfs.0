Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Dec 2007 16:37:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBH0bAtg003941
	for <xfs@oss.sgi.com>; Sun, 16 Dec 2007 16:37:13 -0800
Date: Mon, 17 Dec 2007 11:37:14 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Fedora 8.0.1 XFS Tune on HW RAID for Max Write Throughput?
Message-ID: <20071217003714.GN4396912@sgi.com>
References: <1197653927.3841.1226620089@webmail.messagingengine.com> <4764AB08.7040608@sandeen.net> <20071216233127.GY4612@sgi.com> <Pine.LNX.4.64.0712161847110.5540@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712161847110.5540@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Alex Madarasz <List.XFS@madalexlists.nospammail.net>, xfs@oss.sgi.com

On Sun, Dec 16, 2007 at 06:47:26PM -0500, Justin Piszcz wrote:
> 
> The mkfs.xfs defaults will be just fine for a HW raid device?

If you get a mkfs.xfs from CVS. When barry releases an updated xfsprogs
tarball the defaults from there will be as we've been talking about.

You may still need to tweak sunit/swidth for hardware raid (depending
on you config) but that is no different to now....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
