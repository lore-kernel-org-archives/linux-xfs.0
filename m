Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 05:31:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QCVKTH017617
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:31:20 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F94E182BA28
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:32:20 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.152]) by cuda.sgi.com with ESMTP id hIrCB1xG3uWKRkQv for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:32:20 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so4730fgb.8
        for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 05:32:20 -0700 (PDT)
Message-ID: <6101e8c40806260532j3bed1c7k9a60c41ea297549f@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:32:19 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: [XFS] kernel panic on halt (2.6.26-rc7)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@sandeen.net>, Matthew Wilcox <matthew@wil.cx>

Hi Christoph, Dave,

a similar problem came out the with 2.6.26, than the was in post early
with 2.6.25[1][2]

http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00807.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00808.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00809.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00810.jpg
http://students.zipernowsky.hu/~oliverp/upload/xfs_error_2.6.26/dsc00811.jpg

the git head is on 2.6.26-rc7,
was an any kind of bigger load however here, only desktop usage

the compiler is GCC-4.3.1 gcc (Debian 4.3.1-2) 4.3.1
pc: i386 (Pentium 4 HT Northwood, with enabled HT )

fs usage: 88%


--
[1] http://archives.free.net.ph/thread/20080616.100122.14303e7a.en.html
[2] http://students.zipernowsky.hu/~oliverp/upload/xfs_error/
-- 
Thanks,
Oliver
