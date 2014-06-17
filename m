Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 871EB7F3F
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 03:27:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6961C8F804C
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 01:26:58 -0700 (PDT)
Received: from awesome.dsw2k3.info ([217.188.63.246]) by cuda.sgi.com with
	ESMTP id SlBu1Q13UtUa7fkH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 01:26:56 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by awesome.dsw2k3.info (Postfix) with ESMTP id A9F68BFB74
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 10:24:20 +0200 (CEST)
Received: from awesome.dsw2k3.info ([127.0.0.1])
	by localhost (awesome.dsw2k3.info [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xsLUUHag-Yfd for <xfs@oss.sgi.com>;
	Tue, 17 Jun 2014 10:24:19 +0200 (CEST)
Received: from citd.de (p57A6788B.dip0.t-ipconnect.de [87.166.120.139])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by awesome.dsw2k3.info (Postfix) with ESMTPSA
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2014 10:24:19 +0200 (CEST)
Date: Tue, 17 Jun 2014 10:26:51 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: V5 format and man mkfs.xfs
Message-ID: <20140617082651.GA27971@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi



How seriously meant is "V5 isn't experimental anymore"?

I ask because the man-page only mentions the syntax to enable it by 
accident. A.k.a. the backport of ftype to V4.
(man-page of xfsprogs 3.2.0 in Debian-SID)

And you still have to know that crc means V5.




-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
