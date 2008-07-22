Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 21:42:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M4gSJ5016436
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 21:42:28 -0700
Date: Tue, 22 Jul 2008 00:43:37 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Export xfs_attr_set_int_trans
Message-ID: <20080722044337.GA10290@infradead.org>
References: <1215675545-2707-5-git-send-email-xaiki@sgi.com> <1215754695-6958-1-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215754695-6958-1-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 03:38:14PM +1000, Niv Sardi wrote:
> make xfs_attr_set_int_trans non static so we can use it outside of xfs_attr.c
> (Needed to use it in vnodeops.c, for create+EA)

Any reason this is not merged into the previous patch?
