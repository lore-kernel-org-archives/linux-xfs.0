Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 May 2007 10:56:08 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l46Hu4fB005398
	for <linux-xfs@oss.sgi.com>; Sun, 6 May 2007 10:56:05 -0700
Received: from localhost (dslb-084-057-122-104.pools.arcor-ip.net [84.57.122.104])
	by mail.lichtvoll.de (Postfix) with ESMTP id 3A3FF5AD40
	for <linux-xfs@oss.sgi.com>; Sun,  6 May 2007 19:56:03 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS crash on linux raid
Date: Sun, 6 May 2007 19:56:02 +0200
References: <20070503164521.16efe075@harpe.intellique.com> <20070504234357.24d22883@galadriel.home> <20070505205617.GB17112@tuatara.stupidest.org> (sfid-20070506_174955_742323_AFBCDD13)
In-Reply-To: <20070505205617.GB17112@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705061956.02375.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Samstag 05 Mai 2007 schrieb Chris Wedgwood:
> On Fri, May 04, 2007 at 11:43:57PM +0200, Emmanuel Florac wrote:
> > Unfortunately ext3 doesn't support volumes bigger than 8TB, so
> > that's useless to me. I plan to test jfs, however.
>
> Is jfs supported by anyone right now?

David 'Dave' Kleikamp was still taking care of JFS as I asked him some 
questions about write barrier support back in July 2007. He concentrated 
on bug fixes tough, not on new features.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
