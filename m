Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 16:31:17 -0700 (PDT)
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.229])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k85NV1DW002138
	for <xfs@oss.sgi.com>; Tue, 5 Sep 2006 16:31:02 -0700
Received: by wx-out-0506.google.com with SMTP id h29so2348870wxd
        for <xfs@oss.sgi.com>; Tue, 05 Sep 2006 16:30:26 -0700 (PDT)
Message-ID: <2260b150609051630w311dcedfgca19fb3e1cd41f95@mail.gmail.com>
Date: Wed, 6 Sep 2006 09:30:25 +1000
From: "Chris Seufert" <seufert@gmail.com>
Subject: Re: Kernel Ooops
In-Reply-To: <20060906083028.I3365803@wobbly.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2260b150609050427p3123cb85q5af484d8b907e6ac@mail.gmail.com>
	 <20060906083028.I3365803@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

Just installed -rc5, all seems well.

Should i be running a fsck after these types of errors?

On 9/6/06, Nathan Scott <nathans@sgi.com> wrote:
> On Tue, Sep 05, 2006 at 09:27:04PM +1000, Chris Seufert wrote:
> > I have had this one before, and i had assumed it had been fixed.
> >
> > System seems very stable running ext3, so i dont 'think' its hardware
> > related, but i am begining to wonder.
>
> This is fixed, what kernel version are you using?  (it was fixed
> in -rc5/6 IIRC).
>
> > RIP  [<ffffffff8031dd16>] xfs_btree_init_cursor+0x48/0x1bd
>
> cheers.
>
> --
> Nathan
>
