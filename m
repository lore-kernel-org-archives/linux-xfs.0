Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 00:17:34 -0800 (PST)
Received: from mars.puhasoft.hu (mars.puhasoft.hu [212.108.197.33])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAU8HPdX004975
	for <linux-xfs@oss.sgi.com>; Fri, 30 Nov 2007 00:17:31 -0800
Received: from localhost (localhost [127.0.0.1])
	by mars.puhasoft.hu (Postfix) with ESMTP id 6B7E94064D9
	for <linux-xfs@oss.sgi.com>; Fri, 30 Nov 2007 09:17:33 +0100 (CET)
Received: from mars.puhasoft.hu ([127.0.0.1])
 by localhost (mars.puhasoft.hu [127.0.0.1]) (amavisd-maia, port 10024)
 with ESMTP id 05638-03 for <linux-xfs@oss.sgi.com>;
 Fri, 30 Nov 2007 09:17:26 +0100 (CET)
Received: from [10.1.0.13] (pool-2694.adsl.interware.hu [213.178.110.134])
	by mars.puhasoft.hu (Postfix) with ESMTP id 1C593406F82
	for <linux-xfs@oss.sgi.com>; Fri, 30 Nov 2007 09:17:26 +0100 (CET)
Message-ID: <474FC712.1010809@tsabi.hu>
Date: Fri, 30 Nov 2007 09:17:22 +0100
From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <tsabi@tsabi.hu>
MIME-Version: 1.0
Subject: Re: XFS performance problems on Linux x86_64
References: <474C8A05.3020604@e-626.net> <20071127220536.GL119954183@sgi.com> <fii8bm$6h5$1@ger.gmane.org> <20071130045808.GK119954183@sgi.com> <474FB90C.4060905@tsabi.hu> <20071130075431.GN119954183@sgi.com>
In-Reply-To: <20071130075431.GN119954183@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hey,

David Chinner írta:
> On Fri, Nov 30, 2007 at 08:17:32AM +0100, TÃ³th Csaba wrote:
>> Hello list,
>>
>> I tried this parameters, and got this results with bonnie++. As i think
>> there isnt any speedup with this parameteres, or i am doing something wrong?
> 
> Try creating more than 16 files in your test. Maybe 160,000 instead?

I believe bonnie++ has a test like that too. (i dont know anything about
wehat tests bonnie++ has exactly)

ok, ty for the reply. I just didnt understanded why i didnt get the same
results.

tsabi
