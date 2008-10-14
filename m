Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 05:54:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ECrsTd021434
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 05:53:55 -0700
Date: Tue, 14 Oct 2008 08:55:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/5] Inode: Allow external initialisers
Message-ID: <20081014125536.GA13296@infradead.org>
References: <1223416332-7026-1-git-send-email-david@fromorbit.com> <1223416332-7026-4-git-send-email-david@fromorbit.com> <48F443A9.70808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F443A9.70808@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Oct 14, 2008 at 05:00:57PM +1000, Lachlan McIlroy wrote:
> Dave, this is modifying files outside fs/xfs.  Who has reviewed this patch?

I have, and it's also Cc'ed to -fsdevel.
