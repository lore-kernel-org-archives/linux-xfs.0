Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jun 2008 05:37:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5FCbcY0028359
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 05:37:39 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06460233643
	for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 05:38:35 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.158]) by cuda.sgi.com with ESMTP id c8D3JaqCihCRm8PH for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 05:38:35 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id l26so3236610fgb.8
        for <xfs@oss.sgi.com>; Sun, 15 Jun 2008 05:38:34 -0700 (PDT)
Message-ID: <6101e8c40806150538h4372dcedob2ab9c45aa01741c@mail.gmail.com>
Date: Sun, 15 Jun 2008 14:38:33 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: XFS errors / BUG / panic, with 2.6.25.7-queue (and older 2.6.25.y)
In-Reply-To: <48547604.9060700@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6101e8c40806141241h4a23f7a6ka5366c84130f1291@mail.gmail.com>
	 <48547604.9060700@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Wright <chrisw@sous-sol.org>, Christoph Hellwig <hch@infradead.org>, stable@kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Miquel van Smoorenburg <mikevs@xs4all.net>, Konstantin Kletschke <lists@ku-gbr.de>

this mistake shutdownkor comes out, remount launched because he
panics, only Alt+Sysrq+foo works

On 6/15/08, Eric Sandeen <sandeen@sandeen.net> wrote:
> Oliver Pinter wrote:
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00775.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00776.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00777.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00778.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00779.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00780.jpg
>> http://students.zipernowsky.hu/~oliverp/upload/xfs_error/dsc00781.jpg
>>
>> tainted with: nvidia and madwifi
>> kernel: 2.6.25.6 + queue patches (queue head on
>> aa8edcb997ff605bd1424630356866b78ef06cdc)
>>
>
> What sort of remount were you doing?
>
> -Eric
>


-- 
Thanks,
Oliver
