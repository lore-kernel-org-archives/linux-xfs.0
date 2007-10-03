Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 10:58:23 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l93HwHm9023388
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 10:58:19 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Replace XFS bit functions with Linux functions
Date: Wed, 3 Oct 2007 19:58:13 +0200
References: <200710021010.58284.ak@suse.de> <470273C1.60300@thebarn.com>
In-Reply-To: <470273C1.60300@thebarn.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031958.13422.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com


> I would like to keep thing abstracted enough such that it is won't be to
> difficult keep to map to the FreeBSD bit functions.

It's no different to map linux bit functions to FreeBSD than mapping
XFS bit functions to FreeBSD. Besides I expect it has fls already -- 
that is actually a BSDism.

-Andi
