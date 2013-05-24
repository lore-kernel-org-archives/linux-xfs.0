Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 331E17F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 20:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B16A5AC003
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:37:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XcUPOdSgLqjSSxSk for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 18:37:05 -0700 (PDT)
Date: Thu, 23 May 2013 21:36:59 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524013659.GA25979@redhat.com>
References: <20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524012625.GH24543@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, May 24, 2013 at 11:26:25AM +1000, Dave Chinner wrote:

 > You want to print the debug output if the masked value != 0.

Derp. Thanks.
Rerunning the tests now. Hopefully I'll have something in a few hours.

	Dave


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
