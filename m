Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 07CFC7F9C
	for <xfs@oss.sgi.com>; Mon,  2 Feb 2015 00:35:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB32A8F8081
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 22:34:59 -0800 (PST)
Received: from mail-pa0-f52.google.com (mail-pa0-f52.google.com
	[209.85.220.52]) by cuda.sgi.com with ESMTP id G74NozfvozfCFyfW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 01 Feb 2015 22:34:58 -0800 (PST)
Received: by mail-pa0-f52.google.com with SMTP id kx10so78347656pab.11
	for <xfs@oss.sgi.com>; Sun, 01 Feb 2015 22:34:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALJmpHO1MiPRFvE9P2mU0rtRgcftfNc3XXnxb=nPVYWt-=fU9g@mail.gmail.com>
References: <54c1c12e.230a460a.4729.11fc@mx.google.com>
	<20150128015757.GT16552@dastard>
	<CALJmpHP=vjz_ZY9sFpW8k2Y7TL+sz-WyjPeMoy4sM6XDTt8MTQ@mail.gmail.com>
	<20150128205956.GA6282@dastard>
	<CALJmpHOFVZer7YL8Kek6jk2U8f7JyBrJknYzVhyowht_EGm7DQ@mail.gmail.com>
	<20150130013456.GA4251@dastard>
	<CALJmpHO1MiPRFvE9P2mU0rtRgcftfNc3XXnxb=nPVYWt-=fU9g@mail.gmail.com>
Date: Mon, 2 Feb 2015 12:04:58 +0530
Message-ID: <CALJmpHP58aRYRMhgtyoZ=v2=WMMt+HMX93=n69LfC-8WK8hekw@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs_spaceman: Accounting for AGFL blocks
From: Dhruvesh Rathore <adrscube@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

Hi Dave,

On Fri, Jan 30, 2015 at 1:55 PM, Dhruvesh Rathore <adrscube@gmail.com> wrote:
> http://oss.sgi.com/archives/xfs/2015-01/msg00484.html
> http://oss.sgi.com/archives/xfs/2015-01/msg00486.html
> http://oss.sgi.com/archives/xfs/2015-01/msg00487.html
> http://oss.sgi.com/archives/xfs/2015-01/msg00488.html
> http://oss.sgi.com/archives/xfs/2015-01/msg00489.html

We were wondering if you had a chance to review the above sent patches. :)

Regards,
A-DRS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
