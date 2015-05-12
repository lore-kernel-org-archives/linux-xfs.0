Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE1AB7F3F
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 07:02:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFDB98F8070
	for <xfs@oss.sgi.com>; Tue, 12 May 2015 05:01:59 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id re6JGRrI2z3k4neY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 May 2015 05:01:57 -0700 (PDT)
Message-ID: <5551EBB2.9010508@profihost.ag>
Date: Tue, 12 May 2015 14:01:54 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
Subject: any chance for xfs shrinking?
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

while cloud / vms usage become more and more popular and qemu now also
offers memory hot add and unplug, cpu hot add and unplug, we still
suffer from a missing xfs shrink.

I would like to continue to use XFS as it is a rock solid base since
around 10 years for us.

But one missing piece in variable ressource usage for us is disk
shrinking. Is there any chance to get an xfs online shrinking?

Thanks!

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
