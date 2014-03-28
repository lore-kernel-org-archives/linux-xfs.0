Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47B2E7F6A
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 15:09:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3B5D98F8084
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 13:09:54 -0700 (PDT)
Received: from mail-ve0-f169.google.com (mail-ve0-f169.google.com
	[209.85.128.169]) by cuda.sgi.com with ESMTP id
	VoRVW5A3qbyDUFC0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 13:09:53 -0700 (PDT)
Received: by mail-ve0-f169.google.com with SMTP id pa12so6488508veb.28
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 13:09:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
References: <DF4B0D0E-6D5A-4670-9301-A1DCD0EEAE6E@anti-paladin.com>
Date: Fri, 28 Mar 2014 21:09:52 +0100
Message-ID: <CAAxjCEyJVMcUEGswe-QJigrKiy3peadpyiRv=ey8Wq1z2k==pA@mail.gmail.com>
Subject: Re: Exponential memory usage?
From: Stefan Ring <stefanrin@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Tap <tap@anti-paladin.com>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On Fri, Mar 28, 2014 at 6:53 PM, Tap <tap@anti-paladin.com> wrote:
> My questions are:
>
> 1.  Is this expected?
>
> 2.  Are there any XFS memory calculators that would have shown me this is a problem to begin with?
>
>
> Given it walks out of 32 GB of memory I can't be sure that upgrading to 64 or 128 GB will *ever* help this situation.
>
> Note:  FWIW Un-mounting the filesystem also recovers the memory.

How do you determine that the system runs out of memory?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
