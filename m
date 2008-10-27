Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 06:36:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9RDaRfY021623
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:28 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AA9BADE49C
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id ixFFicmqiQZnrfBA for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 06:36:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KuSGg-0000CE-Pu
	for xfs@oss.sgi.com; Mon, 27 Oct 2008 13:36:26 +0000
Date: Mon, 27 Oct 2008 09:36:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] remove xfs_vfsops.h
Message-ID: <20081027133626.GA717@infradead.org>
References: <20081027133337.GD31125@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027133337.GD31125@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon, Oct 27, 2008 at 09:33:37AM -0400, Christoph Hellwig wrote:
> The only think left is xfs_do_force_shutdown which already has a defintion
> in xfs_mount.h, too.

The only *thing* of course ;-)
