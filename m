Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A670E7F50
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 14:45:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 82FCF8F8033
	for <xfs@oss.sgi.com>; Tue, 29 Jan 2013 12:45:35 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id aj0lJeo36EupsNZZ for <xfs@oss.sgi.com>;
	Tue, 29 Jan 2013 12:45:34 -0800 (PST)
Message-ID: <510834ED.2080404@sandeen.net>
Date: Tue, 29 Jan 2013 14:45:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] xfs: add agskip=value mount option
References: <20130129153914.801475275@sgi.com>
	<20130129153914.976867239@sgi.com>
In-Reply-To: <20130129153914.976867239@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On 1/29/13 9:39 AM, rjohnston@sgi.com wrote:

<an attachment>

Please do inline if possible?

But anyway, although I've not looked at the patch itself yet,
please also add this to Documentation/filesystems/xfs.txt

And not just the "what" but the "why" - why would a person
use this?  And how would they select the value?

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
