Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 31 Aug 2008 19:07:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m81272d4010971
	for <xfs@oss.sgi.com>; Sun, 31 Aug 2008 19:07:02 -0700
Date: Sun, 31 Aug 2008 22:08:27 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW #2]  Update kernel code to compile in userspace
	(libxfs)
Message-ID: <20080901020826.GA31724@infradead.org>
References: <op.ugmy3u2o3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.ugm1ttzb3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080829181120.GA9455@infradead.org> <op.ugr4zpyv3jf8g2@pc-bnaujok.melbourne.sgi.com> <20080901015950.GA16825@infradead.org> <op.ugr5hsao3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugr5hsao3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Sep 01, 2008 at 12:06:54PM +1000, Barry Naujok wrote:
>> Looks good.
>>
>
> What about the rest ;)

Same comments apply - looks good except that in a few places less
ifdef blocks would be nice.  But we can do thes later if this helps you.
