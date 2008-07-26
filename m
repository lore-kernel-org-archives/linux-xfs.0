Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 26 Jul 2008 09:29:40 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6QGTbXf026283
	for <xfs@oss.sgi.com>; Sat, 26 Jul 2008 09:29:37 -0700
Date: Sat, 26 Jul 2008 12:30:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 981875 - xfs_dm_rdwr() needs to pass a vfsmount to
	dentry_open()
Message-ID: <20080726163044.GA11528@infradead.org>
References: <20080516045732.F12DC58C4C29@chook.melbourne.sgi.com> <20080516051048.GB5035@infradead.org> <20080520064356.GA8711@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520064356.GA8711@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Not only is this buggy stuff still there, but it also sneaked into
linux-next were it shold be reverted ASAP.
