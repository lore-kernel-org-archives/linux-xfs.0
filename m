Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C82437F3F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 07:27:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC3348F804C
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 05:27:32 -0700 (PDT)
Received: from mail-pd0-f181.google.com (mail-pd0-f181.google.com
	[209.85.192.181]) by cuda.sgi.com with ESMTP id
	uiEHdhBBl6Y2nlzH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 05:27:30 -0700 (PDT)
Received: by pdbqa5 with SMTP id qa5so9498846pdb.1
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 05:27:30 -0700 (PDT)
Received: from galea.xtremenitro.org
	(static-ip-103.52.2.2.merahciptamedia.com. [103.52.2.2])
	by mx.google.com with ESMTPSA id
	zf1sm16115046pbc.43.2015.05.12.05.27.27 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 12 May 2015 05:27:29 -0700 (PDT)
Message-ID: <5551F1AD.9080804@xtremenitro.org>
Date: Tue, 12 May 2015 19:27:25 +0700
From: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Re: any chance for xfs shrinking?
References: <5551EBB2.9010508@profihost.ag>
In-Reply-To: <5551EBB2.9010508@profihost.ag>
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
To: xfs@oss.sgi.com

Hello!

It's been discussed couple months ago,
Please check it here http://oss.sgi.com/archives/xfs/2015-02/msg00252.html

On 05/12/2015 07:01 PM, Stefan Priebe - Profihost AG wrote:
> Hi,
> 
> while cloud / vms usage become more and more popular and qemu now also
> offers memory hot add and unplug, cpu hot add and unplug, we still
> suffer from a missing xfs shrink.
> 
> I would like to continue to use XFS as it is a rock solid base since
> around 10 years for us.
> 
> But one missing piece in variable ressource usage for us is disk
> shrinking. Is there any chance to get an xfs online shrinking?
> 
> Thanks!
> 
> Greets,
> Stefan
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
