Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Oct 2008 10:11:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9HHBLfg010093
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 10:11:23 -0700
Received: from ag-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1896BABD80C
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 10:13:04 -0700 (PDT)
Received: from ag-out-0708.google.com (ag-out-0708.google.com [72.14.246.244]) by cuda.sgi.com with ESMTP id 0RHZsfbWG9odtmHx for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 10:13:04 -0700 (PDT)
Received: by ag-out-0708.google.com with SMTP id 31so1030872agc.5
        for <xfs@oss.sgi.com>; Fri, 17 Oct 2008 10:13:04 -0700 (PDT)
Message-ID: <a4423d670810171013g5bc19c1cm3f7d9c014ee70349@mail.gmail.com>
Date: Fri, 17 Oct 2008 21:13:04 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: BUG: sleeping function called from invalid context at kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
In-Reply-To: <20081017165738.GA20818@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com>
	 <20081017164116.GA17375@infradead.org>
	 <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
	 <20081017165738.GA20818@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

2008/10/17 Christoph Hellwig <hch@infradead.org>:
> Very strange.  Can you retry with tomorrow Linux-next which should have
> a large XFS update?  If it still happens I'll investigate it in more
> detail.

I have tried next-20081016 with the same result.
I am afraid I wont be able to test it tomorrow, it will likely be
possible on Monday.
