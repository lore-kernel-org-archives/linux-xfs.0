Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 13 Oct 2008 23:51:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9E6pjLu030104
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:51:46 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED46A130BE08
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:53:27 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id I4IjuDBK5a80urRV for <xfs@oss.sgi.com>; Mon, 13 Oct 2008 23:53:27 -0700 (PDT)
Date: Tue, 14 Oct 2008 17:53:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] Inode: Allow external initialisers
Message-ID: <20081014065300.GN10716@disturbed>
References: <1223416332-7026-1-git-send-email-david@fromorbit.com> <1223416332-7026-4-git-send-email-david@fromorbit.com> <48F443A9.70808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F443A9.70808@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Tue, Oct 14, 2008 at 05:00:57PM +1000, Lachlan McIlroy wrote:
> Dave, this is modifying files outside fs/xfs.  Who has reviewed this patch?

It's been posted to -fsdevel twice without anyone commenting
except for Christoph....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
