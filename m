Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 11:13:37 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.185])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l97IDVvB020114
	for <linux-xfs@oss.sgi.com>; Sun, 7 Oct 2007 11:13:34 -0700
Received: by nf-out-0910.google.com with SMTP id e27so958698nfd
        for <linux-xfs@oss.sgi.com>; Sun, 07 Oct 2007 11:13:32 -0700 (PDT)
Message-ID: <5d96567b0710071045q1472a3c7p39d2f707f54d496c@mail.gmail.com>
Date: Sun, 7 Oct 2007 19:45:41 +0200
From: Raz <raziebe@gmail.com>
Subject: Re: mounting raid5 with different unit values
In-Reply-To: <20071007145213.GA4504@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d96567b0710070015j723810aag20dc3e2866868684@mail.gmail.com>
	 <20071007145213.GA4504@puku.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@oss.sgi.com

On 10/7/07, Chris Wedgwood <cw@f00f.org> wrote:
> On Sun, Oct 07, 2007 at 09:15:23AM +0200, Raz wrote:
>
> > mount -osunit=6144,swidth=18432 /dev/md1 /d1/
>
> those values are set when you make the filesystem, not mount it
>
> see the mkfs.xfs man page
>
it was possible to mkfs the file system in different units in 2.6.15,
but it is is not possible to mkfs it with differrent unit sizes in
2.6.17.

-- 
Raz
