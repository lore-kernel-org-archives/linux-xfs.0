Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 18:10:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B1AJIU016585
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 18:10:19 -0700
Date: Fri, 11 Jul 2008 03:11:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/3] simplify xfs_setattr
Message-ID: <20080711011114.GB20486@lst.de>
References: <20080627154557.GB31476@lst.de> <20080705172021.GA7177@lst.de> <48747DAD.7060501@sgi.com> <20080709162914.GA16308@lst.de> <4876AA39.804@sgi.com> <20080711010759.GA11558@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711010759.GA11558@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 11:07:59AM +1000, Dave Chinner wrote:
> It's just that someone here NACKed the mainline patches to the
> NFS server to set this flag.... ;)

Get proper hsm support in mainline and we can talk about enhancing
subsystems to deal with it.
