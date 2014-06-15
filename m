Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A13E7F4E
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 13:58:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66A0A8F8078
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 11:58:52 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	2LDI8UAd5oAAFfhy (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Jun 2014 11:58:50 -0700 (PDT)
Received: by mail-ig0-f172.google.com with SMTP id l13so2163059iga.17
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2014 11:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201406151856.s5FIuv1p015399@refuge.colorado.edu>
References: <201406151856.s5FIuv1p015399@refuge.colorado.edu>
Date: Sun, 15 Jun 2014 20:58:50 +0200
Message-ID: <CAFLt3pjJ5iepFEAwsq1q1NWjQYHb7xNV8sOFk-kTPrvAcez1fg@mail.gmail.com>
Subject: Re: v5 on-disk format
From: Grozdan <neutrino8@gmail.com>
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
To: Eric Roseman <Eric.Roseman@colorado.edu>
Cc: Xfs <xfs@oss.sgi.com>

On Sun, Jun 15, 2014 at 8:56 PM, Eric Roseman <Eric.Roseman@colorado.edu> wrote:
> With the new v5 on-disk format is there a way upgrade existing file
> systems, or does this require a re-mkfs?

There is no way to upgrade. You have to re-create

>
> Thanks,
> Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



-- 
Yours truly

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
