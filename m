Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 17:09:41 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F09aZm024367
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 17:09:36 -0700
Message-ID: <48F542E3.9090506@sgi.com>
Date: Wed, 15 Oct 2008 11:09:55 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] Inode: Allow external initialisers
References: <1223416332-7026-1-git-send-email-david@fromorbit.com> <1223416332-7026-4-git-send-email-david@fromorbit.com> <48F443A9.70808@sgi.com> <20081014125536.GA13296@infradead.org>
In-Reply-To: <20081014125536.GA13296@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

Okay.  Thanks Christoph.

Christoph Hellwig wrote:
> On Tue, Oct 14, 2008 at 05:00:57PM +1000, Lachlan McIlroy wrote:
>> Dave, this is modifying files outside fs/xfs.  Who has reviewed this patch?
> 
> I have, and it's also Cc'ed to -fsdevel.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
