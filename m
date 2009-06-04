Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n54BQfa2239491 for <xfs@oss.sgi.com>; Thu, 4 Jun 2009 06:26:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB7ED10541F2
	for <xfs@oss.sgi.com>; Thu,  4 Jun 2009 04:33:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id o9dCNW1SjOQsCUjA for
	<xfs@oss.sgi.com>; Thu, 04 Jun 2009 04:33:37 -0700 (PDT)
Date: Thu, 4 Jun 2009 07:26:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090604112657.GA10738@infradead.org>
References: <20090520003745.GA27491@samad.com.au>
	<20090520090558.GQ16929@discord.disaster>
	<20090520095639.GA27496@samad.com.au>
	<20090526090916.GA17194@infradead.org>
	<20090527025457.GA32668@samad.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090527025457.GA32668@samad.com.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: randrik@mail.ru, Martin Spott <Martin.Spott@mgras.net>
Cc: xfs@oss.sgi.com

Sorry guys, still haven't been able to track it down.  Any chance one
of you could run with CONFIG_XFS_DEBUG enabled and see if it trips
over any of the asserts?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
