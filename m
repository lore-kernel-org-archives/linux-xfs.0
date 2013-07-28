Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B304329DFC
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 10:48:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92FAA304032
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 08:48:36 -0700 (PDT)
Received: from benjamin.baylink.com (rrcs-24-129-180-187.se.biz.rr.com
	[24.129.180.187]) by cuda.sgi.com with ESMTP id
	ddq4UgDU5nawbh4b for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 08:48:32 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by benjamin.baylink.com (Postfix) with ESMTP id DB9D61F003D4
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 11:48:16 -0400 (EDT)
Received: from benjamin.baylink.com ([127.0.0.1])
	by localhost (benjamin.baylink.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id ipPGHAJvEx6v for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 11:48:12 -0400 (EDT)
Received: from benjamin.baylink.com (benjamin.baylink.com [192.168.253.10])
	by benjamin.baylink.com (Postfix) with ESMTP id 7863D1F00325
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 11:48:12 -0400 (EDT)
Date: Sun, 28 Jul 2013 11:48:12 -0400 (EDT)
From: Jay Ashworth <jra@baylink.com>
Message-ID: <12587602.2462.1375026492464.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <CAAxjCEwwmu_4Xxc8xyPw5Jk2LLTag93698M_EQZb7TxnsVSqXw@mail.gmail.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
MIME-Version: 1.0
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

> The thing is, that RHEL XFS and mainline XFS seem to have drifted
> apart a good deal, and as result, for an outsider, it is very
> difficult to correlate patches between the two branches.

Exactly why I recommended the OP talk to the appropriate kernel packagers.

How my clariyfing that turned into my being an entitled snobby jerk is
entirely unclear to me.

Cheers,
-- jra
-- 
Jay R. Ashworth                  Baylink                       jra@baylink.com
Designer                     The Things I Think                       RFC 2100
Ashworth & Associates     http://baylink.pitas.com         2000 Land Rover DII
St Petersburg FL USA               #natog                      +1 727 647 1274

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
