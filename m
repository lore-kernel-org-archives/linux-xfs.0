Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qADFMxNt101260 for <xfs@oss.sgi.com>; Tue, 13 Nov 2012 09:22:59 -0600
Date: Tue, 13 Nov 2012 09:24:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfs: Remove boolean_t typedef completely.
Message-ID: <20121113152459.GW31970@sgi.com>
References: <CACnwZYd2kPaK1urLYc8BBuuqD7_Oo1oF+KvqWYj7DAEGy6grHQ@mail.gmail.com>
	<20121113015318.GD25039@dastard>
	<CACnwZYeutkdb+=yYx8XcXHSDhaP6QBjgn1BEnGAMYDO7biAtFw@mail.gmail.com>
	<20121113023207.GZ9783@sgi.com>
	<CACnwZYfVXmy74Fpn0eqa63Zgc89fP9BPoRxXf-=_MhENddjnSw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CACnwZYfVXmy74Fpn0eqa63Zgc89fP9BPoRxXf-=_MhENddjnSw@mail.gmail.com>
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
To: Thiago Farina <tfransosi@gmail.com>
Cc: Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

Hey Thiago,

On Tue, Nov 13, 2012 at 01:16:43PM -0200, Thiago Farina wrote:
> On Tue, Nov 13, 2012 at 12:32 AM, Ben Myers <bpm@sgi.com> wrote:
> >> >> > Also, can you please place patches in line rather than attaching
> >> >> > them. Attaching them means they cannot be quoted in reply. See
> >> >> > Documentation/SubmittingPatches and Documentation/email-clients.txt
> >> >> > for guidelines.
> None of these docs say anything about send-email.
> 
> >> > It's still attached as a base64 encoded attachment, not as inline
> >> > text....
> >> >
> >> Yep, sorry about that. Is just a text file from $(git format-patch master);
> >
> > If you don't mind another try...
> No, thanks. It's too painful to use git send-email, the patch is
> attached, if you want to take it, then fine, if not then it's fine too
> :)

Ok then, no problem.  I can make an accomodation.  Thanks for the patch!  :)

FYI, there are other options than git send-email that work fine too.  Plenty of
folks are using 'quilt mail' and that is fairly painless.  I suggest you take a
peek at that if you're going to post on a regular basis.

Thanks again,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
