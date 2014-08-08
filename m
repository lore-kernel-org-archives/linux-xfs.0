Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8EBB57F77
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 14:23:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CBA530406A
	for <xfs@oss.sgi.com>; Fri,  8 Aug 2014 12:23:49 -0700 (PDT)
Received: from mail-qa0-f67.google.com (mail-qa0-f67.google.com
	[209.85.216.67]) by cuda.sgi.com with ESMTP id CPWxSanClXJ0cmma
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Aug 2014 12:23:47 -0700 (PDT)
Received: by mail-qa0-f67.google.com with SMTP id v10so1793179qac.10
	for <xfs@oss.sgi.com>; Fri, 08 Aug 2014 12:23:46 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 8 Aug 2014 21:23:46 +0200
Message-ID: <CA+o=1OVY0pV18XMKz98dT5LGwE500DQQb5B1wh=HaGTAGuP+oQ@mail.gmail.com>
Subject: Verifier fixes backported to stable kernels?
From: Fanael Linithien <fanael4@gmail.com>
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

Will the verifier fixes get backported to 3.15 and/or 3.16, or do we
have to wait for 3.17?

I don't want to wait for 3.17. My / has just been eaten by this bug,
and I'm reluctant to reinstall until it's fixed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
