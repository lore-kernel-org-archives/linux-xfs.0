Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 16:58:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5ANw4tK032557
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:58:05 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC46A17AA72A
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:59:00 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id 2mmiEkuIBPW3O0QC for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 16:59:00 -0700 (PDT)
Message-ID: <484F1541.7010203@firstfloor.org>
Date: Wed, 11 Jun 2008 01:58:57 +0200
From: Andi Kleen <andi@firstfloor.org>
MIME-Version: 1.0
Subject: Re: XFS directory entries sort order
References: <200806101245.09950.dizzy@roedu.net> <87prqpp5q7.fsf@basil.nowhere.org> <op.ucj4nqkv3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ucj4nqkv3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: dizzy <dizzy@roedu.net>, xfs@oss.sgi.com


> readdir order is not dependant on the hashes. The order depends on the
> order of files being created, unlinked and the length of the filenames
> being unlinked/created.

Thanks for the correction. It's a long time that I read that source
so it probably got confused with some other fs.

-Andi
