Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59258 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751033AbcK1SAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 13:00:13 -0500
Subject: Re: New package locations of xfsprogs vs. xfsdump
References: <583C5CDC.6050009@applied-asynchrony.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a588c917-945f-30ab-59f6-946a31b96e19@sandeen.net>
Date: Mon, 28 Nov 2016 12:00:12 -0600
MIME-Version: 1.0
In-Reply-To: <583C5CDC.6050009@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>, linux-xfs@vger.kernel.org

On 11/28/16 10:35 AM, Holger Hoffstätte wrote:
> Hi,
> 
> I just bumped my xfsprogs on Gentoo to 4.8.0 to use the new download location
> at kernel.org and noticed that xfsdump is still at sgi.com, even though it has
> an empty directory at https://www.kernel.org/pub/linux/utils/fs/xfs/xfsdump/.
> 
> Is xfsdump supposed to be there as well or has that migration just not
> happened yet? Just asking for packaging reasons.

It's just that there hasn't been a release since the move.  New versions
should land on kernel.org.

I think Dave was looking into rebuilding and re-releasing old versions
onto kernel.org, but I'm not sure if that has progressed.

-Eric

> thanks,
> Holger
