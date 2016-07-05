Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 586517CE7
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 15:34:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 29685304059
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 13:34:53 -0700 (PDT)
Received: from mail-oi0-f42.google.com (mail-oi0-f42.google.com
	[209.85.218.42]) by cuda.sgi.com with ESMTP id DlsQLIOGIOkSHPBt
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2016 13:34:50 -0700 (PDT)
Received: by mail-oi0-f42.google.com with SMTP id s66so245285681oif.1
	for <xfs@oss.sgi.com>; Tue, 05 Jul 2016 13:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
References: <3ED34739A4E85E4F894367D57617CDEF9ED9518B@LAX-EX-MB2.datadirect.datadirectnet.com>
	<20160704225226.GD27480@dastard> <20160705001854.GY12670@dastard>
	<3ED34739A4E85E4F894367D57617CDEF9ED955AB@LAX-EX-MB2.datadirect.datadirectnet.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 5 Jul 2016 14:34:49 -0600
Message-ID: <CAJCQCtRiznrWAmCEgd=uMETnBubh1ZttGP4xF9PLu0_j7XBRuw@mail.gmail.com>
Subject: Re: Bad Metadata performances for XFS?
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
To: Wang Shilong <wshilong@ddn.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jul 4, 2016 at 7:43 PM, Wang Shilong <wshilong@ddn.com> wrote:
>
>
> I understand that this is single thread Limit, but I guess there are some
> other Limit here, because even single thread creating 50W files speed
> is twice than 200W files.

Watts or Wolframs (tungsten)?

50W!=50000. You could write it as 50k and 200k. It's unlikely to get
confused with 50K and 200K, which are temperatures, because of
context. But W makes no sense.



-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
