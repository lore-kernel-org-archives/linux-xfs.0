Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 19:19:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F2JPb7008271
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 19:19:26 -0700
Date: Tue, 14 Oct 2008 22:21:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 988141 - Fix build error - use VFS_I() to access linux
	inode from xfs inode
Message-ID: <20081015022106.GA22939@infradead.org>
References: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015021055.6B76358FA1E9@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

FYI I sent this patch out first on 22nd of August, and pinged it on 29th
of Semptember..
