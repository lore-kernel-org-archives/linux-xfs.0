Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PEhYsd128896 for <xfs@oss.sgi.com>; Fri, 25 May 2012 09:43:34 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id MpMsKurBaOQCAgGQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 07:43:28 -0700 (PDT)
Date: Fri, 25 May 2012 16:43:26 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/6] build: rename to configure.ac
In-Reply-To: <20120525103632.GA1707@infradead.org>
Message-ID: <alpine.LNX.2.01.1205251641430.14283@frira.zrqbmnf.qr>
References: <1337930323-575-1-git-send-email-jengelh@inai.de>
	<1337930323-575-2-git-send-email-jengelh@inai.de>
	<20120525103632.GA1707@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Friday 2012-05-25 12:36, Christoph Hellwig wrote:

>On Fri, May 25, 2012 at 09:18:38AM +0200, Jan Engelhardt wrote:
>> This is simply the modern recommended name. (As a side note, it also
>> selects the right syntax coloring because .ac tells more than .in.)
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>
>Looks good, but you'll need to send it as a proper patch.

git-am does not take unified diff with git extensions (like renames)?
If you are ok with all six patches, you could also use a 
git fetch+merge/pull, and add any *-by: tags in the merge commit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
