Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 22:29:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B5Trsd027790
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 22:29:54 -0700
Message-ID: <4876F00C.7090307@sgi.com>
Date: Fri, 11 Jul 2008 15:30:52 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix reference counting race on log buffers
References: <1215752481-6862-1-git-send-email-david@fromorbit.com> <4876EED7.8060004@sgi.com>
In-Reply-To: <4876EED7.8060004@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Timothy Shimmin wrote:
> Dave,
> 
> Yeah, looks good. Thanks.
> (My personal preference is for reversing if/else than using !
>  as it is easier to read but whatever :)
> 
> But will need Eric's result before checking it in.
> 

And please push straight to Linus as I won't be able to check it in
today as about to go to QLD.

Thanks,
--Tim
