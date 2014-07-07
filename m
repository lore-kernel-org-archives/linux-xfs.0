Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E75207F3F
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 05:39:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 87BD3AC002
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2014 03:39:30 -0700 (PDT)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id iQHal9b6BMBUINMN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Jul 2014 03:39:25 -0700 (PDT)
Received: by mail-qa0-f46.google.com with SMTP id i13so3278885qae.33
	for <xfs@oss.sgi.com>; Mon, 07 Jul 2014 03:39:24 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Jul 2014 12:39:24 +0200
Message-ID: <CAA85NCgBzB2UUskEAsE-3MuSmoPL_xjteRwxxUuxvwihydfVCQ@mail.gmail.com>
Subject: Re: Data loss XFS with RT kernel on Debian.
From: Jan de Kruyf <jan.de.kruyf@gmail.com>
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

I did post the prob in the Austin Schuh thread in the RT mailing list.
I believe they know what Austins problem is, but Thomas G. is a bit
busy it seems at the moment.

And I did start reading that thread also.
In any case kernel 3.2-rt works great with good latencies, so we will
stick to that for the time being. It was just 'feature inflation' that
made me move to a later kernel. Not always a good idea.

Thanks for your prompt answers.

j.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
