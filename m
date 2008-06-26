Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 05:49:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QCmu3I020801
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:48:56 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09AF6287211
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:49:56 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id UshRNuw754NZoKhk for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:49:56 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so7853fgb.8
        for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:49:55 -0700 (PDT)
Message-ID: <6101e8c40806260549m63ca2899hd1d13de0bd36a6d4@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:49:54 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: [XFS] kernel panic on halt (2.6.26-rc7)
In-Reply-To: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Matthew Wilcox <matthew@wil.cx>

(this an other machine, than the earlier)

and same problem[1]

[1] http://archives.free.net.ph/message/20080616.045221.1905ae63.en.html
[2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg


On 6/26/08, Oliver Pinter <oliver.pntr@gmail.com> wrote:
> Hi Christoph, Dave,
>
> a similar problem came out the with 2.6.26, than the was in post early
> with 2.6.25[1][2]
>
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
> http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg
>
> the git head is on 2.6.26-rc7,
> was an any kind of bigger load however here, only desktop usage
>
> the compiler is GCC-4.3.1 gcc (Debian 4.3.1-2) 4.3.1
> pc: i386 (Pentium 4 HT Northwood, with enabled HT )
>
> fs usage: 88%
>
>
> --
> [1] http://archives.free.net.ph/thread/20080616.100122.14303e7a.en.html
> [2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error/
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
