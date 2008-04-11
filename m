Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 01:46:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B8kE6k019803
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 01:46:16 -0700
Date: Fri, 11 Apr 2008 10:46:46 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/2] simplify xfs_lock_for_rename
Message-ID: <20080411084646.GA13313@lst.de>
References: <20080410184413.GB6771@lst.de> <op.t9fi87c93jf8g2@pc-bnaujok.melbourne.sgi.com> <20080411073730.GA9236@lst.de> <op.t9fuef1t3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.t9fuef1t3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Apr 11, 2008 at 06:40:53PM +1000, Barry Naujok wrote:
> I've already applied your patches to my workarea. Certainly makes my
> CI code simpler.

I haveåa new rename patch ready aswell, it's half-way through xfsqa so
far.
