Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 28 Apr 2007 05:26:14 -0700 (PDT)
Received: from nz-out-0506.google.com (nz-out-0506.google.com [64.233.162.225])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3SCQAfB016487
	for <xfs@oss.sgi.com>; Sat, 28 Apr 2007 05:26:11 -0700
Received: by nz-out-0506.google.com with SMTP id m22so1307820nzf
        for <xfs@oss.sgi.com>; Sat, 28 Apr 2007 05:26:09 -0700 (PDT)
Message-ID: <5d96567b0704280457t464e5c3fm81a9e22a5608751@mail.gmail.com>
Date: Sat, 28 Apr 2007 14:57:19 +0300
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: XFS on x86_64 Linux Question
In-Reply-To: <Pine.LNX.4.64.0704280636220.7998@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
	 <Pine.LNX.4.64.0704280636220.7998@p34.internal.lan>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org

Justin hello
I have tested 32 to 64 bit porting of linux raid5 and xfs and LVM
it worked. though i cannot say I have tested throughly. it was a POC.

On 4/28/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> With correct CC'd address.
>
>
> On Sat, 28 Apr 2007, Justin Piszcz wrote:
>
> > Hello--
> >
> > Had a quick question, if I re-provision a host with an Intel Core Duo CPU
> > with x86_64 Linux; I create a software raid array and use the XFS
> > filesystem-- all in 64bit space...
> >
> > If I boot a recovery image such as Knoppix, it will not be able to work on
> > the filesystem correct?  I would need a 64bit live CD?
> >
> > Does the same apply to software raid?  Can I mount a software raid created in
> > a 64bit environment in a 32bit environment?
> >
> > Justin.
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Raz
